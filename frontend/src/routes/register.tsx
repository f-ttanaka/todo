import { useSnackbar } from '@/contexts/SnackBarContext';
import { useCreateUser } from '@/hooks/api/user';
import { createFileRoute, useNavigate } from '@tanstack/react-router';
import { useState } from 'react';

function RegisterPage() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const { mutate: createUser } = useCreateUser();
  const navigate = useNavigate();
  const { showSnackbar } = useSnackbar();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    createUser(
      { name: username, password },
      {
        onSuccess: () =>
          navigate({
            to: '/login',
          }),
        onError: (e) => showSnackbar(e.message, 'error'),
      },
    );
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-gray-100">
      <div className="w-full max-w-sm bg-white p-6 rounded-2xl shadow-md">
        <h2 className="text-2xl font-bold text-center mb-4">Register</h2>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium">User Name</label>
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              className="w-full p-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium">Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full p-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400"
              required
            />
          </div>
          <button
            type="submit"
            className="w-full bg-blue-500 text-white p-2 rounded-lg hover:bg-blue-600 transition"
          >
            Register
          </button>
        </form>
      </div>
    </div>
  );
}

export const Route = createFileRoute('/register')({
  component: () => <RegisterPage />,
});
