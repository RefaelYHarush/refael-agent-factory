import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'Agent Factory - Build Your AI Agent Army',
  description: 'Create, manage, and deploy AI agents without code. Visual workflow designer, agent marketplace, and real-time analytics.',
  keywords: ['AI', 'agents', 'automation', 'workflow', 'no-code', 'LLM'],
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        {children}
      </body>
    </html>
  );
}
