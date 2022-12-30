import Head from 'next/head'
import Image from 'next/image'
import styles from '../styles/Home.module.css'

export async function getServerSideProps() {
  const res = await fetch(`http://127.0.0.1:3100/todo`, {method: 'GET'})
  const data = await res.json()

  return { props: { data } }
}

export default function Home(props) {
  const table_define = [
    {label: 'id', key: 'id'},
    {label: 'comment', key: 'comment'}
  ];

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
                {table_define.map((def) => (
                  <th>{def.label}</th>
                ))}
                <th>-</th>
              </tr>
            </thead>
            <tbody>
                {props.data.map((row) => (
                  <tr>
                    <th key={row.id}>{row.id}</th>
                    <td key={row.comment}>{row.comment}</td>
                    <td> <button>削除</button></td>
                  </tr>
                ))}
            </tbody>
          </table>
        </div>

        <div className={styles.center}>
        <h2>新しいTodoの追加</h2>
          <form>
            内容 <input id="new_todo" type="text"/>
            <button>追加</button>
          </form>
        </div>
      </main>
    </>
  )
}
