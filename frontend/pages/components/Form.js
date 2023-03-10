import React, { useState } from "react";

export default function Form(props) {
  const [name, setName] = useState("");

  function handleChange(e) {
    setName(e.target.value);
  }

  async function handleSubmit(e) {
    e.preventDefault();
    await props.addTask(name);
    window.location.reload();
  }

  return (
    <form onSubmit={handleSubmit}>
      <h2 className="label-wrapper">
        <label htmlFor="new-todo-input" className="label__lg">
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
        onChange={handleChange}
        minLength={1} required
        maxLength={50}
      />
      <button type="submit" className="btn btn__primary btn__lg">
        Add
      </button>
    </form>
  );
}
