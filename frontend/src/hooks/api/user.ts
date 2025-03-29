import { useMutation } from '@tanstack/react-query';

export function useLogin() {
  return useMutation({
    mutationFn: async ({
      name,
      password,
    }: {
      name: string;
      password: string;
    }) => {
      const response = await fetch('/api/login', {
        method: 'POST',
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
  });
}

export function useCreateUser() {
  return useMutation({
    mutationFn: async ({
      name,
      password,
    }: {
      name: string;
      password: string;
    }) => {
      const response = await fetch('/api/user', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          userName: name,
          userPassword: password,
        }),
      });

      if (!response.ok) {
        throw new Error('request error');
      }

      const data = await response.text();
      return data;
    },
  });
}
