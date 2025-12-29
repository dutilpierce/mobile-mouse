export const metadata = { title: "Mobile Mouse Admin" };

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body style={{ fontFamily: "system-ui", margin: 0, background: "#0b0b10", color: "#f5f5f7" }}>
        {children}
      </body>
    </html>
  );
}
