import AuthContext from '@/context/auth';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useNavigate } from '@tanstack/react-router';
import { useContext } from 'react';

const apiRoot = '/api/login';

export function useLogin() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({
      name,
      password,
    }: {
      name: string;
      password: string;
    }) => {
      const response = await fetch(apiRoot, {
        method: 'POST',
        mode: 'cors',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          userName: name,
          userPassword: password,
        }),
        credentials: 'include',
      });

      if (!response.ok) {
        throw new Error('request error');
      }

      const data = await response.text();
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['todo'] });
    },
  });
}
