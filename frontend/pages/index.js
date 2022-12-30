import Head from 'next/head'
import styles from '../styles/Home.module.css'
import React, { useState } from 'react'

export async function getServerSideProps() {
  const res = await fetch(`http://127.0.0.1:3100/todo`, {method: 'GET'})
  const data = await res.json()

  return { props: { data } }
}

export function postAPI(props, text) {
  const res = fetch(`http://127.0.0.1:3100/todo`, {
      method: 'POST',
      mode: 'cors',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({id: props.data.length + 1, comment: text})
  });

  return res;
}

export function deleteAPI(n) {
  const res = fetch(`http://127.0.0.1:3100/todo/${n}`, {
    method: 'DELETE',
    mode: 'cors',
    headers: {
      'Content-Type': 'application/json',
    },
  })

  return res;
}

export function putAPI(n,text) {
  const res = fetch(`http://127.0.0.1:3100/todo/`, {
    method: 'PUT',
    mode: 'cors',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({id: n, comment: text})
  })

  return res;
}

export default function Home(props) {
  const tableDefine = [
    {label: 'id', key: 'id'},
    {label: 'comment', key: 'comment'}
  ];

  const [todo, setTodo] = useState("");

  async function handleSubmit(e) {
    e.preventDefault();
    const postResponse = await postAPI(props, todo);
    console.log(postResponse);
    window.location.reload();
  }

  function handleChangeSubmit(e) {
    setTodo(e.target.value)
  }

  async function handleDelete(e,n) {
    e.preventDefault();
    const deleteResponse = await deleteAPI(n);
    console.log(deleteResponse);
    window.location.reload();
  }

  async function handlePut(e,n,text) {
    e.preventDefault();
    const putResponse = await putAPI(n,text);
    console.log(putResponse);
    window.location.reload();
  }

  return (
    <>
      <Head>
        <title>Todo</title>
        <meta name="description" content="Todo application" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main className={styles.main}>
        <div className={styles.center}>
          <table>
            <thead>
              <tr>
                {tableDefine.map((def) => (
                  <th>{def.label}</th>
                ))}
                <th>-</th>
                <th>-</th>
              </tr>
            </thead>
            <tbody>
                {props.data.map((row) => (
                  <tr>
                    <th key={row.id}>{row.id}</th>
                    <td key={row.comment}>{row.comment}</td>
                    <td> <button onClick={(e) => handleDelete(e,row.id)}>削除</button></td>
                    <td> <button onClick={(e) => handlePut(e,row.id, '編集テスト')}>編集</button> </td>
                  </tr>
                ))}
            </tbody>
          </table>
        </div>

        <div className={styles.center}>
        <h2>新しいTodoの追加</h2>
          <form onSubmit={handleSubmit}>
            内容 <input id="newTodo" name="newTodo" value={todo} onChange={handleChangeSubmit} type="text"/>
            <button type="submit">追加</button>
          </form>
        </div>
      </main>
    </>
  )
}
