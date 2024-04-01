import { useEffect, useState } from 'react'
import { useTodos } from '@/hooks/api'
import type { Todo } from '@/hooks/api'
import FilterButton from '@/components/FiterButton'
import Form from '@/components/Form'
import TodoTemplate from '@/components/Todo'

type Filter = 'All' | 'Active' | 'Completed'

const Todos = () => {
  const [filter, setFilter] = useState<Filter>('All')
  const [todos, setTodos] = useState<Todo[] | null>(null)
  const data = useTodos()
  useEffect(() => {
    data.then((ts) => setTodos(ts))
  }, [])

  console.log(data);

  const filteredTodos = todos?.filter((todo) => {
    switch (filter) {
      case 'All':
        return true
      case 'Active':
        return !todo.completed
      case 'Completed':
        return todo.completed
    }
  })

  return (
    <div className='flex flex-col items-center h-full w-full'>
      <div className='p-4'>
        <p className='text-3xl font-bold tracking-normal'>TodoMatic</p>
      </div>
      <Form />
      <div className='flex gap-4'>
        <FilterButton label='All' onClick={() => setFilter('All')} />
        <FilterButton label='Active' onClick={() => setFilter('Active')} />
        <FilterButton label='Completed' onClick={() => setFilter('Completed')} />
      </div>
      <h2 id='list-heading'>{filteredTodos?.length ?? 0} tasks remaining</h2>
      <ul
        role='list'
        className='todo-list stack-large stack-exception'
        aria-labelledby='list-heading'
      >
        {filteredTodos?.map(({ title, uuid, completed }) => (
          <TodoTemplate key={uuid} title={title} uuid={uuid} completed={completed} />
        ))}
      </ul>
    </div>
  )
}

const Home = () => (
  <div className='h-screen w-screen'>
    <Todos />
  </div>
)

export default Home
