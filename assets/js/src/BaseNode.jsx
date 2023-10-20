import React, { memo } from "react";
import { Handle, Position } from "reactflow";
import { Link } from "react-router-dom";

export default memo(({ data }) => {
  return (
    <>
      <Link to={`/my/stories/${data.storyId}/nodes/${data.id}`}>
        <div className="bg-white rounded p-4">
          <span className="text-black">{data.label}</span>
        </div>
      </Link>
      <Handle
        type="source"
        position={Position.Right}
        id={data.id}
        className="bg-white right-[-6px] w-3 h-3 shadow-md border-2 border-black z-10"
      />
      {!data.initial && (
        <Handle
          type="target"
          position={Position.Left}
          id={data.id}
          className="bg-white left-[-6px] w-3 h-3 shadow-md border-2 border-black z-10"
        />
      )}
    </>
  );
});
