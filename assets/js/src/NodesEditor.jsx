import React, { useCallback, useEffect, useRef, useState } from "react";
import Dagre from "dagre";
import ReactFlow, {
  Background,
  useNodesState,
  useEdgesState,
  addEdge,
  useReactFlow,
  ReactFlowProvider,
} from "reactflow";
import BaseNode from "./BaseNode";
import EditPanel from "./NodeEditPanel";
import { useQuery } from "@apollo/client";
import { GET_STORY } from "../graphql/queries";
import { CREATE_NODE } from "../graphql/mutations";
import { useMutation } from "@apollo/client";
import { useParams, useNavigate } from "react-router-dom";

const baseNode = ({ id, label, initial, storyId }) => ({
  id,
  position: { x: 0, y: 0 },
  type: "base",
  sourcePosition: "right",
  data: {
    initial,
    id,
    label,
    storyId,
  },
});

const generateNodes = (nodes, initialNodeId) => {
  if (!nodes.length || !initialNodeId) {
    return [];
  }

  return nodes.map((node) => {
    return baseNode({
      id: node.id,
      storyId: node.storyId,
      label: node.title,
      initial: node.id === initialNodeId,
    });
  });
};

const generateEdges = (choices) =>
  choices.map((choice) => ({
    id: choice.id,
    source: choice.originNodeId,
    target: choice.targetNodeId,
    animated: true,
  }));

const nodeTypes = {
  base: BaseNode,
};

const g = new Dagre.graphlib.Graph().setDefaultEdgeLabel(() => ({}));

const getLayoutedElements = (nodes, edges) => {
  g.setGraph({ rankdir: "LR" });

  edges.forEach((edge) => g.setEdge(edge.source, edge.target));
  nodes.forEach((node) => g.setNode(node.id, node));

  Dagre.layout(g);

  g.nodes().forEach((node) => {
    console.log(g.node(node));
  });

  return {
    nodes: nodes.map((node) => {
      const { x, y } = g.node(node.id);
      const multplier = 5;
      return { ...node, position: { x: x * multplier, y: y * multplier } };
    }),
    edges,
  };
};

const NodesEditor = () => {
  const { storyId, nodeId } = useParams();
  const { project, fitView } = useReactFlow();
  const [editPanelOpen, setEditPanelOpen] = useState(true);
  const [createNode] = useMutation(CREATE_NODE);

  const { data } = useQuery(GET_STORY, {
    variables: { id: storyId },
  });

  useEffect(() => {
    setEditPanelOpen(!!nodeId);
  }, [nodeId]);

  useEffect(() => {
    if (data?.story) {
      const nodes = generateNodes(data.story.nodes, data.story.startingNodeId);
      const edges = generateEdges(data.story.choices);
      const layouted = getLayoutedElements(nodes, edges);

      setNodes([...layouted.nodes]);
      setEdges([...layouted.edges]);

      window.requestAnimationFrame(() => {
        fitView();
      });
    }
  }, [data]);

  const reactFlowWrapper = useRef(null);
  const connectingNodeId = useRef(null);
  const [nodes, setNodes, onNodesChange] = useNodesState([]);
  const [edges, setEdges, onEdgesChange] = useEdgesState([]);
  const onConnect = useCallback(
    (params) => setEdges((eds) => addEdge(params, eds)),
    [data]
  );

  const createNewNode = useCallback(
    async (event) => {
      console.log("createTemporaryNewNode", event);

      const { data } = await createNode({
        variables: {
          nodeInput: {
            title: "New Node",
            storyId: storyId,
            body: "<p>New Node</p>",
            originNodeId: connectingNodeId.current,
          },
        },
      });

      console.log("createTemporaryNewNode", data);

      // const { top, left } = reactFlowWrapper.current.getBoundingClientRect();
      // const newNode = {
      //   id,
      //   type: "base",
      //   position: project({
      //     x: event.clientX - left - 75,
      //     y: event.clientY - top,
      //   }),
      //   data: { label: "New node", storyId, initial: false, id: `${id}` },
      // };

      // setNodes((nds) => nds.concat(newNode));
      // setEdges((eds) =>
      //   eds.concat({ id, source: connectingNodeId.current, target: id })
      // );
      // navigate(`/my/stories/${storyId}/nodes/new`);
    },
    [project]
  );

  const onConnectStart = useCallback((_, { nodeId }) => {
    connectingNodeId.current = nodeId;
  }, []);

  const onConnectEnd = useCallback(
    (event) => {
      const targetIsPane = event.target.classList.contains("react-flow__pane");

      if (targetIsPane) {
        createNewNode(event);
      }
    },
    [project]
  );

  const edgesWithUpdatedTypes = edges.map((edge) => {
    if (edge.sourceHandle) {
      const edgeType = nodes.find((node) => node.type === "custom").data
        .selects[edge.sourceHandle];
      edge.type = edgeType;
    }

    return edge;
  });

  const proOptions = { hideAttribution: true };

  const story = data?.story;

  if (!story) {
    return null;
  }
  const selectedNode = story.nodes.find((node) => node.id === nodeId);

  return (
    <div className="relative text-white h-full" ref={reactFlowWrapper}>
      <ReactFlow
        nodes={nodes}
        edges={edgesWithUpdatedTypes}
        onNodesChange={onNodesChange}
        onEdgesChange={onEdgesChange}
        onConnect={onConnect}
        onConnectStart={onConnectStart}
        onConnectEnd={onConnectEnd}
        fitView
        proOptions={proOptions}
        nodeTypes={nodeTypes}
      >
        <Background color="#6b7280" style={{ backgroundColor: "#111827" }} />
      </ReactFlow>
      <EditPanel open={editPanelOpen} storyId={storyId} node={selectedNode} />
    </div>
  );
};

export default () => (
  <ReactFlowProvider>
    <NodesEditor />
  </ReactFlowProvider>
);
