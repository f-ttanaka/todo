import { useCreateTodo } from '@/hooks/api'
import React, { useState } from 'react'

const Form = () => {
  const [name, setName] = useState('')
  const { create } = useCreateTodo(name)
  const inputId = 'new-todo-input'

  return (
    <form onSubmit={create}>
      <div className='flex flex-col'>
        <label htmlFor={inputId} className='text-xl'>
          What needs to be done?
        </label>
        <div className='flex gap-2 p-2'>
          <input
            type='text'
            id={inputId}
            name='text'
            autoComplete='off'
            value={name}
            onChange={(e) => setName(e.target.value)}
            minLength={1}
            required
            maxLength={50}
          />
          <button type='submit' className='bg-blue-50'>
            Add
          </button>
        </div>
      </div>
    </form>
  )
}

export default Form
