import Link from "next/link";
export default function Page() {
  return (
    <main style={ padding: 24, maxWidth: 960, margin: "0 auto" }>
      <p style={ opacity: 0.75 }><Link href="/">← Home</Link></p>
      <h1 style={ marginTop: 0 }>Content & Updates</h1>
      <p>Stub module — wire to FastAPI in <code>server/</code> when ready.</p>
    </main>
  );
}
