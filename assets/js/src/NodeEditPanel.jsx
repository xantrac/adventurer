import React, { Fragment, useState } from "react";
import { Transition } from "@headlessui/react";
import { Link } from "react-router-dom";
import Editor from "./components/Editor";
import Button from "./components/Button";
import { Form, Input } from "./components/form";
import { useForm } from "react-hook-form";
import { useMutation } from "@apollo/client";
import { CREATE_NODE, UPDATE_NODE } from "../graphql/mutations";
import { GET_STORY } from "../graphql/queries";

export default function NodeEditPanel({ open, storyId, node }) {
  const nodeId = node?.id;
  const { register, handleSubmit } = useForm({
    defaultValues: { title: node?.title || "" },
  });
  const [editor, setEditor] = useState(null);
  const mutation = nodeId ? UPDATE_NODE : CREATE_NODE;
  const [mutate] = useMutation(mutation, { refetchQueries: [GET_STORY] });
  const onSubmit = async (data) => {
    const body = editor.getHTML();
    const variables = { nodeInput: { ...data, body }, id: nodeId };

    const { data: result } = await mutate({ variables });
  };

  const editorContent = node?.body || "";

  return (
    <Transition.Root show={open} as={Fragment}>
      <div
        className="relative z-10 text-black"
        aria-labelledby="slide-over-title"
        role="dialog"
        aria-modal="true"
      >
        <div className="absolute inset-0 overflow-hidden">
          <div className="pointer-events-none fixed inset-y-0 right-0 flex max-w-full pl-10 sm:pl-16">
            <Transition.Child
              as={Fragment}
              enter="transform transition ease-in-out duration-500 sm:duration-700"
              enterFrom="translate-x-full"
              enterTo="translate-x-0"
              leave="transform transition ease-in-out duration-500 sm:duration-700"
              leaveFrom="translate-x-0"
              leaveTo="translate-x-full"
            >
              <div className="pointer-events-auto w-screen max-w-2xl bg-white flex flex-col p-4">
                <Form onSubmit={handleSubmit(onSubmit)}>
                  <div className="grid grid-cols-1 gap-x-6 gap-y-8 sm:grid-cols-6">
                    <div className="col-span-full">
                      <input
                        type="hidden"
                        {...register("storyId")}
                        value={storyId}
                      />
                      <Input required {...register("title")} />
                    </div>
                    <div className="col-span-full">
                      <Editor
                        setEditor={setEditor}
                        name="body"
                        content={editorContent}
                      />
                    </div>
                  </div>
                  <div className="flex space-x-2 justify-end">
                    <Link to={`/my/stories/${storyId}/nodes`}>
                      <Button version={"secondary"}>Cancel</Button>
                    </Link>
                    <Button>Submit</Button>
                  </div>
                </Form>
              </div>
            </Transition.Child>
          </div>
        </div>
      </div>
    </Transition.Root>
  );
}
