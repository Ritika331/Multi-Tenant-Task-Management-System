import axios from "axios";

const api = axios.create({
  baseURL: "http://localhost:8080",
});

api.interceptors.request.use((config) => {
  const orgId = localStorage.getItem("orgId") || 1;
  config.headers["X-ORG-ID"] = orgId;
  return config;
});

export default api;
