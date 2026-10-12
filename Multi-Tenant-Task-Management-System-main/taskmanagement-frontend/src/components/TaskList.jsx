export default function TaskList({ tasks, onEdit, onDelete }) {
  if (!tasks || tasks.length === 0) {
    return <p className="empty-text">No tasks found.</p>;
  }

  return (
    <table className="task-table">
      <thead>
        <tr>
          <th>Title</th>
          <th>Status</th>
          <th>Assigned User</th>
          <th>Created</th>
          <th>Actions</th>
        </tr>
      </thead>

      <tbody>
        {tasks.map((task) => (
          <tr key={task.id}>
            <td>{task.title}</td>

            <td>
              <span className={`status ${task.status}`}>
                {task.status}
              </span>
            </td>

            <td>{task.assignedUserName || "-"}</td>

            <td>
              {new Date(task.createdAt).toLocaleDateString()}
            </td>

            <td>
              <button onClick={() => onEdit(task)}>Edit</button>
              <button onClick={() => onDelete(task.id)}>Delete</button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}