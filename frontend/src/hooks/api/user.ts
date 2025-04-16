import { useMutation } from '@tanstack/react-query';

async function handleResponse(resp: Response) {
  if (!resp.ok) {
    console.log(resp);
    throw new Error('request error');
  }

  const data = await resp.text();
  return data;
}

export function useLogin() {
  return useMutation({
    mutationFn: async ({
      name,
      password,
    }: {
      name: string;
      password: string;
    }) => {
      const resp = await fetch('/api/login', {
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

      return handleResponse(resp);
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
      const resp = await fetch('/api/user', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          userName: name,
          userPassword: password,
        }),
      });

      return handleResponse(resp);
    },
  });
}
