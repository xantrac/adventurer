import React, { useCallback, useEffect, useRef, useState } from "react";
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
import { useParams } from "react-router-dom";

const baseNode = ({ id, label, initial, storyId }) => ({
  id,
  position: { x: 0, y: 0 },
  type: "base",
  sourcePosition: "right",
  data: {
    initial,
    storyId,
    id,
    label,
  },
});

const generateNodes = (nodes, initialNodeId) => {
  if (!nodes.length || !initialNodeId) {
    return [];
  }

  const initialNode = nodes.find((node) => node.id === initialNodeId);

  return [
    baseNode({
      id: initialNode.id,
      storyId: initialNode.storyId,
      label: initialNode.title,
      initial: true,
    }),
  ];
};

const nodeTypes = {
  base: BaseNode,
};

const NodesEditor = () => {
  const { storyId, nodeId } = useParams();
  console.log(storyId, nodeId);
  const { project } = useReactFlow();
  const [editPanelOpen, setEditPanelOpen] = useState(false);

  const { data } = useQuery(GET_STORY, {
    variables: { id: storyId },
  });

  useEffect(() => {
    setEditPanelOpen(!!nodeId);
  }, [nodeId]);

  useEffect(() => {
    if (data?.story) {
      const nodes = generateNodes(data.story.nodes, data.story.startingNodeId);
      setNodes(nodes);
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

  const createTemporaryNewNode = useCallback(
    (event) => {
      const { top, left } = reactFlowWrapper.current.getBoundingClientRect();
      const id = "new-temporary-node-id";
      const newNode = {
        id,
        type: "base",
        position: project({
          x: event.clientX - left - 75,
          y: event.clientY - top,
        }),
        data: { label: `Node ${id}`, initial: false, id: `${id}` },
      };

      setNodes((nds) => nds.concat(newNode));
      setEdges((eds) =>
        eds.concat({ id, source: connectingNodeId.current, target: id })
      );
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
        createTemporaryNewNode(event);
      }
    },
    [project]
  );

  // we are using a bit of a shortcut here to adjust the edge type
  // this could also be done with a custom edge for example
  const edgesWithUpdatedTypes = edges.map((edge) => {
    if (edge.sourceHandle) {
      const edgeType = nodes.find((node) => node.type === "custom").data
        .selects[edge.sourceHandle];
      edge.type = edgeType;
    }

    return edge;
  });

  const proOptions = { hideAttribution: true };

  return (
    <div
      className="relative text-white h-[800px] xl:h-[1000px]"
      ref={reactFlowWrapper}
    >
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
      <EditPanel open={editPanelOpen} storyId={storyId} />
    </div>
  );
};

export default () => (
  <ReactFlowProvider>
    <NodesEditor />
  </ReactFlowProvider>
);
