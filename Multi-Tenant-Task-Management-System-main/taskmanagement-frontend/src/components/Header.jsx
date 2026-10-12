import { useAuth } from "../context/AuthContext";

export default function Header() {
  const { user, logout } = useAuth();

  return (
    <div style={{ marginBottom: "24px" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <div>
          <h1>Task Management Dashboard</h1>
          <p style={{ color: "#666" }}>
            Organization-based task tracking
          </p>
        </div>
        <div style={{ textAlign: "right" }}>
          <p style={{ margin: 0, fontWeight: "bold" }}>{user?.name}</p>
          <p style={{ margin: 0, color: "#666", fontSize: "14px" }}>
            {user?.organizationName}
          </p>
          <button
            onClick={logout}
            style={{
              marginTop: "8px",
              padding: "8px 16px",
              background: "#667eea",
              color: "white",
              border: "none",
              borderRadius: "4px",
              cursor: "pointer",
              fontSize: "14px",
            }}
          >
            Logout
          </button>
        </div>
      </div>
    </div>
  );
}
