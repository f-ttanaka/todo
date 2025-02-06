import { dummyUserUuid } from '@/data/dummyUserUuid';
import type { Todo } from '@/types/todo';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

const apiRoot = '/api/todo';

export function useTodos() {
  return useQuery({
    queryKey: ['todo'],
    queryFn: () =>
      fetch(`${apiRoot}/${dummyUserUuid}`, {
        method: 'GET',
        credentials: 'include',
      })
        .then((response) => {
          const result: Promise<Todo[]> = response.json();
          return result;
        })
        .catch(() => {
          return null;
        }),
  });
}

export function useCreateTodo() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (title: string) =>
      fetch(`${apiRoot}/${dummyUserUuid}`, {
        method: 'POST',
        mode: 'cors',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(title),
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['todo'] });
    },
  });
}

export function useDeleteTodo() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (uuid: string) =>
      fetch(`${apiRoot}/${uuid}`, {
        method: 'DELETE',
        mode: 'cors',
        headers: {
          'Content-Type': 'application/json',
        },
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['todo'] });
    },
  });
}

export function useUpdateTitle(uuid: string, title: string) {
  return useQuery({
    queryKey: ['todo'],
    queryFn: () =>
      fetch(`${apiRoot}/title/${uuid}/${title}`, {
        method: 'PUT',
        mode: 'cors',
        headers: {
          'Content-Type': 'application/json',
        },
      }),
  });
}

export function useUpdateStatus() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (uuid: string) =>
      fetch(`${apiRoot}/state/${uuid}`, {
        method: 'PUT',
        mode: 'cors',
        headers: {
          'Content-Type': 'application/json',
        },
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['todo'] });
    },
  });
}
