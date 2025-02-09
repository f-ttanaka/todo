import { useMutation } from '@tanstack/react-query';

const apiRoot = '/api/login';

export function useLogin() {
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
