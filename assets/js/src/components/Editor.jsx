import React, { useEffect } from "react";
import { useEditor, EditorContent } from "@tiptap/react";
import StarterKit from "@tiptap/starter-kit";
import clsx from "clsx";

const MenuBar = ({ editor }) => {
  if (!editor) {
    return null;
  }

  const className = (isActive) =>
    clsx(
      "rounded text-sm",
      isActive ? "bg-primary-dark text-white" : "bg-white text-primary-dark"
    );

  return (
    <div className="border-b-2 border-primary-dark flex space-x-1 flex-wrap p-1">
      <button
        onClick={() => editor.chain().focus().toggleBold().run()}
        disabled={!editor.can().chain().focus().toggleBold().run()}
        className={className(editor.isActive("bold"))}
      >
        bold
      </button>
      <button
        onClick={() => editor.chain().focus().toggleItalic().run()}
        disabled={!editor.can().chain().focus().toggleItalic().run()}
        className={className(editor.isActive("italic"))}
      >
        italic
      </button>
      <button
        onClick={() => editor.chain().focus().toggleStrike().run()}
        disabled={!editor.can().chain().focus().toggleStrike().run()}
        className={className(editor.isActive("strike"))}
      >
        strike
      </button>
      <button onClick={() => editor.chain().focus().unsetAllMarks().run()}>
        clear marks
      </button>
      <button onClick={() => editor.chain().focus().clearNodes().run()}>
        clear nodes
      </button>
      <button
        onClick={() => editor.chain().focus().setParagraph().run()}
        className={className(editor.isActive("paragraph"))}
      >
        paragraph
      </button>
      <button
        onClick={() => editor.chain().focus().toggleHeading({ level: 1 }).run()}
        className={className(editor.isActive("heading", { level: 1 }))}
      >
        h1
      </button>
      <button
        onClick={() => editor.chain().focus().toggleBlockquote().run()}
        className={className(editor.isActive("blockquote", { level: 1 }))}
      >
        blockquote
      </button>
      <button
        onClick={() => editor.chain().focus().setHardBreak().run()}
        className={className(false)}
      >
        hard break
      </button>
      <button
        onClick={() => editor.chain().focus().undo().run()}
        disabled={!editor.can().chain().focus().undo().run()}
        className={className(false)}
      >
        undo
      </button>
      <button
        onClick={() => editor.chain().focus().redo().run()}
        disabled={!editor.can().chain().focus().redo().run()}
        className={className(false)}
      >
        redo
      </button>
    </div>
  );
};

const extensions = [
  StarterKit.configure({
    bulletList: {
      keepMarks: true,
      keepAttributes: false, // TODO : Making this as `false` becase marks are not preserved when I try to preserve attrs, awaiting a bit of help
    },
    orderedList: {
      keepMarks: true,
      keepAttributes: false, // TODO : Making this as `false` becase marks are not preserved when I try to preserve attrs, awaiting a bit of help
    },
  }),
];

const Tiptap = ({ content, setEditor }) => {
  const editor = useEditor({
    extensions,
    content,
    editorProps: {
      attributes: {
        class: "p-4 outline-none h-96 overflow-y-scroll",
      },
    },
  });

  useEffect(() => {
    setEditor(editor);
  }, [editor]);

  return (
    <div className="border-2 border-primary-dark rounded">
      <MenuBar editor={editor} />
      <EditorContent editor={editor} />
    </div>
  );
};

export default Tiptap;
