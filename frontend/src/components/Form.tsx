import { useCreateTodo } from '../hooks/api'
import React, { useState } from 'react'

const Form = () => {
  const [name, setName] = useState('')
  const { create } = useCreateTodo(name)
  const inputId = 'new-todo-input'

  return (
    <form onSubmit={create}>
      <h2 className='label-wrapper'>
        <label htmlFor={inputId} className='label__lg'>
          What needs to be done?
        </label>
      </h2>
      <input
        type='text'
        className='input input__lg'
        id={inputId}
        name='text'
        autoComplete='off'
        value={name}
        onChange={(e) => setName(e.target.value)}
        minLength={1}
        required
        maxLength={50}
      />
      <button type='submit' className='btn btn__primary btn__lg'>
        Add
      </button>
    </form>
  )
}

export default Form
