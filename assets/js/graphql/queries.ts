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
        storyId
      }
    }
  }
`;

export { GET_STORY };
