async function handleAuthResponse<T>(resp: Response): Promise<T> {
  if (!resp.ok && resp.status === 401) {
    window.location.replace('/login');
  }

  if (!resp.ok) {
    const errorData = await resp.json();
    throw new Error(errorData.error || '送信に失敗しました');
  }

  const data: T = await resp.json();
  return data;
}

export async function getWithAuth<T>(apiRoot: string): Promise<T> {
  const resp = await fetch(apiRoot, {
    method: 'GET',
    credentials: 'include',
  });

  return handleAuthResponse<T>(resp);
}

export async function postWithAuth<T = void, U = undefined>(
  apiRoot: string,
  value?: U,
) {
  const resp = await fetch(apiRoot, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: value ? JSON.stringify(value) : undefined,
  });

  return handleAuthResponse<T>(resp);
}

export async function deleteWithAuth<T = void>(apiRoot: string) {
  const resp = await fetch(apiRoot, {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
  });

  return handleAuthResponse<T>(resp);
}

export async function putWithAuth<T = void, U = undefined>(
  apiRoot: string,
  value?: U,
) {
  const resp = await fetch(apiRoot, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
    },
    body: value ? JSON.stringify(value) : undefined,
  });

  return handleAuthResponse<T>(resp);
}
