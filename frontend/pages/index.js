import React, { useState } from 'react'
import Todo from './components/Todo'
import Form from './components/Form'
import FilterButton from './components/FilterButton'

const FILTER_MAP = {
  All: () => true,
  Active: (task) => !task.completed,
  Completed: (task) => task.completed
};
const FILTER_NAMES = Object.keys(FILTER_MAP);

const URL = 'http://127.0.0.1:3100/api/todo'
const updateTitleURL = URL + '/title'
const updateStateURL = URL + '/state'

export async function getServerSideProps() {
  const res = await fetch(URL, {method: 'GET'})
  const data = await res.json()

  return { props: { data } }
}

export default function Home (props) {
  function postReq(name) {
    const res = fetch(URL, {
      method: 'POST',
      mode: 'cors',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({id: 0, title: name, completed: false})
    });
    return res;
  }
    
  function deleteReq(n) {
    const res = fetch(URL + '/' + n, {
      method: 'DELETE',
      mode: 'cors',
      headers: {
        'Content-Type': 'application/json',
      },
    })
  
    return res;
  }

  function updateTitleReq(n,text) {
    const res = fetch(updateTitleURL, {
      method: 'PUT',
      mode: 'cors',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({id: n, title: text, completed: false})
    })
  
    return res;
  }

  function updateStateReq(n) {
    const res = fetch(updateStateURL + '/' + n, {
      method: 'PUT',
      mode: 'cors',
      headers: {
        'Content-Type': 'application/json',
      },
    })
  
    return res;
  }

  
  const [filter, setFilter] = useState('All');

  const filterList = FILTER_NAMES.map((name) => (
    <FilterButton
      key={name}
      name={name}
      isPressed={name === filter}
      setFilter={setFilter}
    />
  ));

  const taskList = props.data
    .filter(FILTER_MAP[filter])
    .map((task) => (
    <Todo
      id={task.id}
      name={task.title}
      key={task.id}
      completed={task.completed}
      deleteTask={deleteReq}
      editTask={updateTitleReq}
      editState={updateStateReq}
    />
  ));

  return (
    <div className="todoapp stack-large">
      <h1>TodoMatic</h1>
      <Form addTask={postReq} />
      <div className="filters btn-group stack-exception">
        {filterList}
      </div>
      <h2 id="list-heading">
        {taskList.length} tasks remaining
      </h2>
      <ul
        role="list"
        className="todo-list stack-large stack-exception"
        aria-labelledby="list-heading"
      >
        {taskList.sort((a,b) => a.key - b.key)}
      </ul>
    </div>
  );
}