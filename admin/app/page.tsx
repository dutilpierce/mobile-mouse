import Link from "next/link";

export default function Page() {
  return (
    <main style={{ padding: 24, maxWidth: 960, margin: "0 auto" }}>
      <h1 style={{ marginTop: 0 }}>Admin (Starter)</h1>
      <p>This is a starter admin shell reflecting the "Super Admin" scope in the proposal.</p>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))", gap: 12 }}>
        {[
          ["Dashboard", "/dashboard"],
          ["Users", "/users"],
          ["Analytics", "/analytics"],
          ["Content", "/content"],
          ["Billing", "/billing"],
          ["Support", "/support"],
        ].map(([label, href]) => (
          <Link key={href} href={href} style={{ padding: 16, borderRadius: 14, background: "#141423", border: "1px solid #2a2a3a", color: "inherit", textDecoration: "none" }}>
            <strong>{label}</strong>
            <div style={{ opacity: 0.75, marginTop: 6 }}>Stub page</div>
          </Link>
        ))}
      </div>
    </main>
  );
}
