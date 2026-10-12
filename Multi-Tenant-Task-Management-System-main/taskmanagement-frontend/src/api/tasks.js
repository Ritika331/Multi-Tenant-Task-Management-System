import api from "./axios";

export const getTasks = (page = 0, size = 10) => {
  return api.get(`/tasks?page=${page}&size=${size}`);
};

export const createTask = (task) => {
  return api.post("/tasks", task);
};

export const updateTask = (id, task) => {
  return api.put(`/tasks/${id}`, task);
};

export const deleteTask = (id) => {
  return api.delete(`/tasks/${id}`);
};
