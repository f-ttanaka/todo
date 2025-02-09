import type { Todo } from '@/types/todo';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import {
  deleteWithAuth,
  getWithAuth,
  postWithAuth,
  putWithAuth,
} from './common';

const apiRoot = '/api/todo';

export function useTodos() {
  return useQuery({
    queryKey: ['todo'],
    queryFn: () => getWithAuth<Todo[]>(apiRoot),
  });
}

export function useCreateTodo() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (title: string) => postWithAuth<void, string>(apiRoot, title),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['todo'] });
    },
  });
}

export function useDeleteTodo() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (uuid: string) => deleteWithAuth(`${apiRoot}/${uuid}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['todo'] });
    },
  });
}

export function useUpdateStatus() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (uuid: string) => putWithAuth(`${apiRoot}/state/${uuid}`),
    // TODO: refactor
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['todo'] });
    },
  });
}
