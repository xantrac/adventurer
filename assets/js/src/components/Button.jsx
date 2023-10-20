import React from "react";
import clsx from "clsx";

const Button = (props) => {
  const version = props.version || "primary";
  const className = clsx(
    "rounded px-4 py-2 text-medium",
    version === "primary" && "bg-primary-dark text-white",
    version === "secondary" &&
      "bg-white text-primary-dark border border-primary-dark",
    props.className
  );
  const { children, ...rest } = props;
  return (
    <button className={className} {...rest}>
      {children}
    </button>
  );
};

export default Button;
