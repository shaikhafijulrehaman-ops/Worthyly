import React from 'react';

export default class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    console.error('WORTHLY Application Error caught by ErrorBoundary:', error, errorInfo);
  }

  handleReload = () => {
    window.location.reload();
  };

  handleReset = () => {
    this.setState({ hasError: false, error: null });
  };

  render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-screen bg-[#FAF6F0] flex items-center justify-center p-6 text-[#18213A]">
          <div className="max-w-md w-full bg-white/80 backdrop-blur-md border border-[#E6E0D5] rounded-3xl p-8 shadow-xl text-center space-y-5">
            <div className="w-14 h-14 mx-auto rounded-2xl bg-amber-100/80 border border-amber-300/60 flex items-center justify-center text-amber-700 text-2xl font-bold">
              !
            </div>
            <div className="space-y-2">
              <h2 className="text-xl font-bold text-[#101B3D]">Something went wrong</h2>
              <p className="text-xs text-[#69738A] leading-relaxed">
                WORTHLY encountered an unexpected issue while rendering. Your data is safe.
              </p>
            </div>
            <div className="flex items-center justify-center gap-3 pt-2">
              <button
                onClick={this.handleReload}
                className="px-5 py-2.5 bg-[#3559C7] hover:bg-[#2c4cb0] text-white rounded-xl text-xs font-bold transition shadow-sm cursor-pointer"
              >
                Reload WORTHLY
              </button>
              <button
                onClick={this.handleReset}
                className="px-5 py-2.5 bg-white hover:bg-[#F7F1E6] text-[#18213A] border border-[#E6E0D5] rounded-xl text-xs font-semibold transition cursor-pointer"
              >
                Try Again
              </button>
            </div>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}
