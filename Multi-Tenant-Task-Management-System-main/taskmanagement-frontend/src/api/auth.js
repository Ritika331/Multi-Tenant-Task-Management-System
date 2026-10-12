import api from "./axios";

export const login = async (email, password) => {
  const response = await api.post("/auth/login", { email, password });
  return response.data;
};

export const register = async (name, email, password, organizationName) => {
  const response = await api.post("/auth/register", {
    name,
    email,
    password,
    organizationName,
  });
  return response.data;
};
