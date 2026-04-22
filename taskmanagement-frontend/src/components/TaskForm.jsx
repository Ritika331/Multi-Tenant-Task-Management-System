import { useEffect, useState } from "react";

export default function TaskForm({ users, onSubmit, editingTask }) {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [status, setStatus] = useState("TODO");
  const [assignedUserId, setAssignedUserId] = useState("");
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (editingTask) {
      setTitle(editingTask.title);
      setDescription(editingTask.description || "");
      setStatus(editingTask.status);
      setAssignedUserId(editingTask.assignedUserId || "");
    }
  }, [editingTask]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    await onSubmit({
      title,
      description,
      status,
      assignedUserId: assignedUserId || null,
    });

    setTitle("");
    setDescription("");
    setStatus("TODO");
    setAssignedUserId("");
    setLoading(false);
  };

  return (
    <form className="task-form" onSubmit={handleSubmit}>
      <h3>{editingTask ? "Edit Task" : "Create Task"}</h3>

      <input
        type="text"
        placeholder="Task title"
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        required
      />

      <input
        type="text"
        placeholder="Description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
      />

      <select value={status} onChange={(e) => setStatus(e.target.value)}>
        <option value="TODO">TODO</option>
        <option value="IN_PROGRESS">IN_PROGRESS</option>
        <option value="DONE">DONE</option>
      </select>

      {/* ASSIGNED USER DROPDOWN */}
      <select
        value={assignedUserId}
        onChange={(e) => setAssignedUserId(e.target.value)}
      >
        <option value="">Unassigned</option>
        {users.map((user) => (
          <option key={user.id} value={user.id}>
            {user.name}
          </option>
        ))}
      </select>

      <button type="submit" disabled={loading}>
        {loading
          ? editingTask
            ? "Updating..."
            : "Creating..."
          : editingTask
          ? "Update Task"
          : "Create Task"}
      </button>
    </form>
  );
}