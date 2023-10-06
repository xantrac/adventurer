import React from "react";
import NodesEditor from "./src/NodesEditor";
import { render, unmountComponentAtNode } from "react-dom";
import { ApolloClient, InMemoryCache, ApolloProvider } from "@apollo/client";
import { createBrowserRouter, RouterProvider } from "react-router-dom";

const client = new ApolloClient({
  uri: "/graphql",
  cache: new InMemoryCache(),
});

const router = createBrowserRouter([
  {
    path: "/my/stories/:storyId/nodes",
    element: <NodesEditor />,
  },
  {
    path: "/my/stories/:storyId/nodes/:nodeId",
    element: <NodesEditor />,
  },
]);

export function mount(id, opts) {
  const rootElement = document.getElementById(id);

  render(
    <React.StrictMode>
      <ApolloProvider client={client}>
        <RouterProvider router={router} />
      </ApolloProvider>
    </React.StrictMode>,
    rootElement
  );

  return (el) => {
    if (!unmountComponentAtNode(el)) {
      console.warn("unmount failed", el);
    }
  };
}
