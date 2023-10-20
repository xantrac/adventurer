import { gql } from "@apollo/client";

const CREATE_NODE = gql`
  mutation CreateNode($nodeInput: NodeInput!) {
    createNode(nodeInput: $nodeInput) {
      id
      title
    }
  }
`;

const UPDATE_NODE = gql`
  mutation UpdateNode($id: ID!, $nodeInput: NodeInput!) {
    updateNode(id: $id, nodeInput: $nodeInput) {
      id
    }
  }
`;

export { CREATE_NODE, UPDATE_NODE };
