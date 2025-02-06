import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

const apiRoot = '/api/login';

export function useLogin() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ name, password }: { name: string; password: string }) =>
      fetch(`${apiRoot}`, {
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
      })
        .then((response) => {
          // returned user uuid
          const result: Promise<string> = response.json();
          return result;
        })
        .catch((err) => {
          console.error(err);
        }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['todo'] });
    },
  });
}
