const apiRoot = 'http://127.0.0.1:3100/api/todo'

export type Todo = {
  uuid : string,
  title: string,
  completed: boolean,
}

export const useTodos = () => {
  const data = fetch(apiRoot, {method: 'GET'}).then((response) => {
    const result : Promise<Todo[]> = response.json();
    return result;
  }).catch(() => {
    return null;
  })

  return data;
}

export const useCreateTodo = (title: string) => {
  const create = () => fetch(`${apiRoot}/${title}`, {
    method: 'POST',
    mode: 'cors',
    headers: {
      'Content-Type': 'application/json',
    },
  });
  return {create};
}
  
export const useDeleteTodo = (uuid: string) => {
  const deleteTodo = () => fetch(`${apiRoot}/${uuid}`, {
    method: 'DELETE',
    mode: 'cors',
    headers: {
      'Content-Type': 'application/json',
    },
  })

  return {deleteTodo};
}

export const useUpdateTitle =(uuid: string, title: string) => {
  const updateTitle = () => fetch(`${apiRoot}/title/${uuid}/${title}`, {
    method: 'PUT',
    mode: 'cors',
    headers: {
      'Content-Type': 'application/json',
    },
  });
  
  return {updateTitle}
}

export const useUpdateState = (uuid: string) => {
  const updateState = () => fetch(`${apiRoot}/state/${uuid}`, {
    method: 'PUT',
    mode: 'cors',
    headers: {
      'Content-Type': 'application/json',
    },
  })

  return {updateState};
}