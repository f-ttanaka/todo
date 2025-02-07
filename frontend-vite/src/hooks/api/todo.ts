import type { Todo } from '@/types/todo';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

const apiRoot = '/api/todo';

export function useTodos() {
  return useQuery({
    queryKey: ['todo'],
    queryFn: async () => {
      const resp = await fetch(apiRoot, {
        method: 'GET',
        credentials: 'include',
      });

      if (!resp.ok) {
        if (resp.status === 401) {
          window.location.replace('/login');
        }
        throw new Error('Failed to fetch todos');
      }

      const data: Todo[] = await resp.json();
      return data;
    },
  });
}

export function useCreateTodo() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (title: string) =>
      fetch(apiRoot, {
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
