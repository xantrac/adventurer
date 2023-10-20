import { gql } from "@apollo/client";

const GET_STORY = gql`
  query GetStory($id: ID!) {
    story(id: $id) {
      id
      title
      description
      startingNodeId
      nodes {
        id
        title
        body
        storyId
      }
      choices {
        id
        description
        originNodeId
        targetNodeId
      }
    }
  }
`;

export { GET_STORY };
