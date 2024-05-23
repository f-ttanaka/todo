import { useState } from 'react'
import { useDeleteTodo, useUpdateState, useUpdateTitle } from '@/hooks/api'

type ViewTemplateProps = {
  title: string
  value: string
  completed: boolean
  onModeChange: () => void
}

const ViewTemplate = ({ title, value, completed, onModeChange }: ViewTemplateProps) => {
  const { updateState } = useUpdateState(value)
  const { deleteTodo } = useDeleteTodo(value)

  return (
    <div className='stack-small'>
      <div className='c-cb'>
        <input
          id={`view-todo-${value}`}
          type='checkbox'
          defaultChecked={completed}
          readOnly
          disabled
        />
        <label className='todo-label' htmlFor={`view-todo-${value}`}>
          {title}
        </label>
      </div>
      <div className='btn-group'>
        <button type='button' className='btn' onClick={updateState}>
          Change State
        </button>
        <button type='button' className='btn' onClick={onModeChange}>
          Edit <span className='visually-hidden'>{title}</span>
        </button>
        <button type='button' className='btn btn__danger' onClick={deleteTodo}>
          Delete <span className='visually-hidden'>{title}</span>
        </button>
      </div>
    </div>
  )
}

const EditingTemplate = ({
  title,
  value,
  onModeChange,
}: {
  title: string
  value: string
  onModeChange: () => void
}) => {
  const inputId = `edited-title-${value}`
  const [editedTitle, setEditedTitle] = useState(title)
  const { updateTitle } = useUpdateTitle(value, editedTitle)
  return (
    <form className='stack-small' onSubmit={updateTitle}>
      <div className='form-group'>
        <label className='todo-label' htmlFor={inputId}>
          New name for {title}
        </label>
        <input
          id={inputId}
          className='todo-text'
          type='text'
          value={editedTitle}
          onChange={(e) => setEditedTitle(e.target.value)}
          minLength={1}
          required
          maxLength={50}
        />
      </div>
      <div className='btn-group'>
        <button type='button' className='btn todo-cancel' onClick={onModeChange}>
          Cancel
          <span className='visually-hidden'>renaming {title}</span>
        </button>
        <button type='submit' className='btn btn__primary todo-edit'>
          Save
          <span className='visually-hidden'>new name for {title}</span>
        </button>
      </div>
    </form>
  )
}

type TodoProps = {
  uuid: string
  title: string
  completed: boolean
}

const Todo = ({ uuid, title, completed }: TodoProps) => {
  const [isEditing, setEditing] = useState(false)

  return (
    <li className='todo'>
      {isEditing ? (
        <EditingTemplate title={title} value={uuid} onModeChange={() => setEditing(false)} />
      ) : (
        <ViewTemplate
          title={title}
          value={uuid}
          completed={completed}
          onModeChange={() => setEditing(true)}
        />
      )}
    </li>
  )
}

export default Todo
