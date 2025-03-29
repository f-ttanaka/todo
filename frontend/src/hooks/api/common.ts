export async function getWithAuth<T>(apiRoot: string): Promise<T> {
  const resp = await fetch(apiRoot, {
    method: 'GET',
    credentials: 'include',
  });

  if (!resp.ok && resp.status === 401) {
    window.location.replace('/login');
  }

  if (!resp.ok) {
    throw new Error('Failed to fetch data');
  }

  const data: T = await resp.json();
  return data;
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

  if (!resp.ok && resp.status === 401) {
    window.location.replace('/login');
  }

  if (!resp.ok) {
    throw new Error('Failed to post');
  }

  const data: T = await resp.json();
  return data;
}

export async function deleteWithAuth<T = void>(apiRoot: string) {
  const resp = await fetch(apiRoot, {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
  });

  if (!resp.ok && resp.status === 401) {
    window.location.replace('/login');
  }

  if (!resp.ok) {
    throw new Error('Failed to delete');
  }

  const data: T = await resp.json();
  return data;
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

  if (!resp.ok && resp.status === 401) {
    window.location.replace('/login');
  }

  if (!resp.ok) {
    throw new Error('Failed to delete');
  }

  const data: T = await resp.json();
  return data;
}
