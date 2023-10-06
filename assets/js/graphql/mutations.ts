import { gql } from "@apollo/client";

const CREATE_NODE = gql`
  mutation CreateNode($nodeInput: NodeInput!) {
    createNode(nodeInput: $nodeInput) {
      id
    }
  }
`;
