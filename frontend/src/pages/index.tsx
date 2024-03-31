import { useEffect, useState } from "react";
import { useTodos } from "@/hooks/api"
import type {Todo} from "@/hooks/api"
import FilterButton from "@/components/FiterButton"
import Form from "@/components/Form"
import TodoTemplate from "@/components/Todo"

type Filter = "All" | "Active" | "Completed"

const Home = () => {
  const [filter, setFilter] = useState<Filter>('All');
  const [todos, setTodos] = useState<Todo[] | null>(null)
  const data = useTodos();
  useEffect(() => {
    data.then((ts) => setTodos(ts))
  },[])

  const filteredTodos = todos?.filter((todo) => {
    switch(filter) {
      case 'All':
        return true;
      case 'Active':
        return !todo.completed
      case 'Completed':
        return todo.completed
    }
  })

  return (
    <div className="todoapp stack-large">
      <h1>TodoMatic</h1>
      <Form/>
      <div className="filters btn-group stack-exception">
      <FilterButton
      label='All'
      onClick={() => setFilter('All')}
    />
    <FilterButton
      label='All'
      onClick={() => setFilter('All')}
    />
    <FilterButton
      label='All'
      onClick={() => setFilter('All')}
    />
      </div>
      <h2 id="list-heading">
        {filteredTodos?.length ?? 0} tasks remaining
      </h2>
      <ul
        role="list"
        className="todo-list stack-large stack-exception"
        aria-labelledby="list-heading"
      >
        {filteredTodos?.map(({title, uuid, completed}) => (
          <TodoTemplate key={uuid} title={title} uuid={uuid} completed={completed} />
        ))}
      </ul>
    </div>
  );
}

export default Home;