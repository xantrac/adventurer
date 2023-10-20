import React from "react";

const Form = ({ children, ...props }) => {
  return (
    <form {...props} className="flex flex-col h-full justify-between">
      {children}
    </form>
  );
};

const Input = React.forwardRef((props, ref) => {
  return (
    <div>
      <label className="capitalize block text-sm font-medium leading-6 text-gray-900">
        {props.name}
      </label>
      <div className="mt-2">
        <input
          ref={ref}
          {...props}
          className="block w-full rounded-md border-0 py-1.5 px-1 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
        />
      </div>
    </div>
  );
});

export { Form, Input };
