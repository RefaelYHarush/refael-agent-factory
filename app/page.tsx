import Link from 'next/link';
import { ArrowRight, Bot, Workflow, Store, BarChart3 } from 'lucide-react';

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white dark:from-gray-900 dark:to-gray-800">
      {/* Hero Section */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-20 pb-16">
        <div className="text-center">
          <h1 className="text-5xl md:text-7xl font-bold tracking-tight text-gray-900 dark:text-white mb-6">
            Build Your
            <span className="text-blue-600 dark:text-blue-400"> AI Agent Army</span>
          </h1>
          <p className="text-xl md:text-2xl text-gray-600 dark:text-gray-300 mb-8 max-w-3xl mx-auto">
            Create, manage, and deploy AI agents without code. Visual workflow designer, agent marketplace, and real-time analytics.
          </p>
          <div className="flex gap-4 justify-center">
            <Link
              href="/dashboard"
              className="inline-flex items-center px-6 py-3 text-lg font-medium text-white bg-blue-600 hover:bg-blue-700 rounded-lg transition-colors"
            >
              Get Started
              <ArrowRight className="ml-2 h-5 w-5" />
            </Link>
            <Link
              href="/marketplace"
              className="inline-flex items-center px-6 py-3 text-lg font-medium text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg transition-colors"
            >
              Explore Marketplace
            </Link>
          </div>
        </div>

        {/* Features Grid */}
        <div className="mt-24 grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          <FeatureCard
            icon={<Bot className="h-8 w-8 text-blue-600" />}
            title="Agent Builder"
            description="Create custom AI agents with visual editor. No coding required."
          />
          <FeatureCard
            icon={<Workflow className="h-8 w-8 text-purple-600" />}
            title="Workflow Designer"
            description="Drag-and-drop workflow builder. Connect agents seamlessly."
          />
          <FeatureCard
            icon={<Store className="h-8 w-8 text-green-600" />}
            title="Agent Marketplace"
            description="Discover and share agents with the community."
          />
          <FeatureCard
            icon={<BarChart3 className="h-8 w-8 text-orange-600" />}
            title="Real-time Analytics"
            description="Monitor performance and track usage metrics."
          />
        </div>

        {/* Stats */}
        <div className="mt-24 grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
          <Stat number="10,000+" label="Agents Created" />
          <Stat number="50,000+" label="Executions Daily" />
          <Stat number="5,000+" label="Active Users" />
          <Stat number="1,000+" label="Workflows" />
        </div>
      </div>
    </div>
  );
}

function FeatureCard({
  icon,
  title,
  description,
}: {
  icon: React.ReactNode;
  title: string;
  description: string;
}) {
  return (
    <div className="p-6 bg-white dark:bg-gray-800 rounded-xl shadow-sm hover:shadow-md transition-shadow border border-gray-200 dark:border-gray-700">
      <div className="mb-4">{icon}</div>
      <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-2">
        {title}
      </h3>
      <p className="text-gray-600 dark:text-gray-400">{description}</p>
    </div>
  );
}

function Stat({ number, label }: { number: string; label: string }) {
  return (
    <div>
      <div className="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white">
        {number}
      </div>
      <div className="text-sm text-gray-600 dark:text-gray-400 mt-1">
        {label}
      </div>
    </div>
  );
}
