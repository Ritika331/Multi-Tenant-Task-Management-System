import { useEffect, useState } from "react";
import Layout from "../components/Layout";
import Header from "../components/Header";
import TaskForm from "../components/TaskForm";
import TaskList from "../components/TaskList";
import { getTasks, createTask, updateTask, deleteTask } from "../api/tasks";
import{ getUsers } from "../api/users";
import "../styles/dashboard.css";

export default function Dashboard() {
  const [tasks, setTasks] = useState([]);
  const [users, setUsers] = useState([]);
  const [editingTask, setEditingTask] = useState(null);

  const loadTasks = async () => {
    const res = await getTasks();
    setTasks(res.data.content);
  };
  const loadUsers = async() => {
      const res = await getUsers();
      setUsers(res.data);
      };

  useEffect(() => {
    loadTasks();
    loadUsers();
  }, []);

  const handleEdit = (task) => {
    setEditingTask(task);
  };

  const handleDelete = async (taskId) => {
    await deleteTask(taskId);
    loadTasks();
  };

  const handleSubmit = async (taskData) => {
    if (editingTask) {
      await updateTask(editingTask.id, taskData);
      setEditingTask(null);
    } else {
      await createTask(taskData);
    }
    loadTasks();
  };

  return (
    <Layout>
      <Header />

      <TaskForm
        users={users}
        editingTask={editingTask}
        onSubmit={handleSubmit}
      />

      <TaskList
        tasks={tasks}
        onEdit={handleEdit}
        onDelete={handleDelete}
      />
    </Layout>
  );
}
