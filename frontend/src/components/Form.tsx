import { useCreateTodo } from "@/hooks/api";
import React, { useState } from "react"

const Form = () => {
  const [name, setName] = useState("");
  const {create} = useCreateTodo(name);

  return (
    <form onSubmit={create}>
      <h2 className="label-wrapper">
        <label htmlFor="new-todo-input" className="leading-[1.01567]">
          What needs to be done?
        </label>
      </h2>
      <input
        type="text"
        id="new-todo-input"
        className="input input__lg"
        name="text"
        autoComplete="off"
        value={name}
        onChange={(e) => setName(e.target.value)}
        minLength={1} required
        maxLength={50}
      />
      <button type="submit" className="btn btn__primary btn__lg">
        Add
      </button>
    </form>
  );
}

export default Form;