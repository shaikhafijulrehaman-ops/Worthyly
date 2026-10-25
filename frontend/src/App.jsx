import React, { useState, useEffect } from 'react';
import TopNavbar from './components/TopNavbar';
import PageLanding from './pages/PageLanding';
import PageProfile from './pages/PageProfile';
import PageOverview from './pages/PageOverview';
import PageRequirementBuilder from './pages/PageRequirementBuilder';
import PageRecommendations from './pages/PageRecommendations';
import PageProductExplorer from './pages/PageProductExplorer';
import PageCompareProducts from './pages/PageCompareProducts';
import PageCommunityReviews from './pages/PageCommunityReviews';
import PageBudgetFinder from './pages/PageBudgetFinder';
import PageSavedProducts from './pages/PageSavedProducts';
import PageMyReviews from './pages/PageMyReviews';
import PageSettings from './pages/PageSettings';
import ProductDetailsModal from './components/ProductDetailsModal';
import CompareTray from './components/CompareTray';
import AnimatedFooter from './components/AnimatedFooter';
import { api } from './services/api';

export default function App() {
  const [activeTab, setActiveTab] = useState('landing');
  const [profileSubTab, setProfileSubTab] = useState('overview');
  const [products, setProducts] = useState([]);
  const [categories, setCategories] = useState([]);
  const [reviews, setReviews] = useState([]);
  const [savedItems, setSavedItems] = useState([]);
  const [savedComparisons, setSavedComparisons] = useState([]);
  const [comparedProducts, setComparedProducts] = useState([]);
  
  // Selected category for builder
  const [builderCategory, setBuilderCategory] = useState('electronics');
  
  // Recommendations state
  const [recommendationResult, setRecommendationResult] = useState(null);
  const [isRecommending, setIsRecommending] = useState(false);

  // Modal state
  const [selectedProductForModal, setSelectedProductForModal] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);

  // Toast feedback state
  const [toastMessage, setToastMessage] = useState('');

  const showToast = (msg) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(''), 3000);
  };

  // Initial Data Fetching
  const loadData = async () => {
    try {
      const cats = await api.getCategories();
      setCategories(cats);

      const prodsRes = await api.getProducts();
      setProducts(prodsRes.products || []);

      const revsRes = await api.getReviews();
      setReviews(revsRes.reviews || []);

      const savedRes = await api.getSavedProducts();
      setSavedItems(savedRes.saved || []);

      const compsRes = await api.getSavedComparisons();
      setSavedComparisons(compsRes.comparisons || []);
    } catch (err) {
      console.error('Error loading initial data:', err);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  // Handlers
  const handleStartFinding = () => {
    setActiveTab('builder');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleSelectCategoryFromOverview = (catId) => {
    setBuilderCategory(catId);
    setActiveTab('builder');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleSubmitRequirements = async (requirements) => {
    setIsRecommending(true);
    setActiveTab('recommendations');
    window.scrollTo({ top: 0, behavior: 'smooth' });

    try {
      const res = await api.getRecommendations(requirements);
      setRecommendationResult(res);
    } catch (e) {
      console.error('Failed to get recommendations', e);
      showToast('Could not calculate recommendations. Please try again.');
    } finally {
      setIsRecommending(false);
    }
  };

  // Compare actions
  const handleAddToCompare = (product) => {
    if (comparedProducts.some((p) => p.id === product.id)) {
      setComparedProducts(comparedProducts.filter((p) => p.id !== product.id));
      showToast(`Removed "${product.name}" from comparison.`);
    } else {
      if (comparedProducts.length >= 3) {
        showToast('You can compare a maximum of 3 products simultaneously.');
        return;
      }
      setComparedProducts([...comparedProducts, product]);
      showToast(`Added "${product.name}" to comparison (${comparedProducts.length + 1}/3).`);
    }
  };

  const handleRemoveFromCompare = (productId) => {
    setComparedProducts(comparedProducts.filter((p) => p.id !== productId));
  };

  const handleClearCompare = () => {
    setComparedProducts([]);
    showToast('Comparison cleared.');
  };

  const handleNavigateToCompare = () => {
    setActiveTab('compare');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  // Save product action
  const handleToggleSave = async (productId) => {
    const isSaved = savedItems.some((s) => s.product?.id === productId);
    if (isSaved) {
      await api.removeSavedProduct(productId);
      setSavedItems(savedItems.filter((s) => s.product?.id !== productId));
      showToast('Product removed from saved items.');
    } else {
      await api.saveProduct(productId);
      const prod = products.find((p) => p.id === productId);
      if (prod) {
        setSavedItems([
          { savedId: `s-${productId}`, savedAt: new Date().toISOString(), product: prod },
          ...savedItems
        ]);
      }
      showToast('Product bookmarked to your saved shortlist!');
    }
  };

  // Modal actions
  const handleViewDetails = (product) => {
    setSelectedProductForModal(product);
    setIsModalOpen(true);
  };

  // Saved Comparison actions
  const handleSaveComparison = async (comparisonData) => {
    const saved = await api.saveComparison(comparisonData);
    setSavedComparisons([saved, ...savedComparisons]);
    showToast('Comparison shootout saved successfully.');
  };

  const handleDeleteComparison = async (comparisonId) => {
    await api.deleteComparison(comparisonId);
    setSavedComparisons(savedComparisons.filter((c) => c.id !== comparisonId));
    showToast('Comparison removed.');
  };

  const handleReopenComparison = (prods) => {
    setComparedProducts(prods || []);
    setActiveTab('compare');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  // Review actions
  const handleCreateReview = async (reviewData) => {
    const newRev = await api.createReview(reviewData);
    setReviews([newRev, ...reviews]);
    showToast('Your review has been verified and posted!');
  };

  const handleDeleteReview = async (reviewId) => {
    await api.deleteReview(reviewId);
    setReviews(reviews.filter((r) => r.id !== reviewId));
    showToast('Review deleted successfully.');
  };

  const handleReportReview = async (reviewId) => {
    await api.reportReview(reviewId);
    showToast('Review reported to moderators for verification.');
  };

  const handleResetAllDemoData = () => {
    localStorage.clear();
    setComparedProducts([]);
    loadData();
    showToast('All demo cache and preferences reset to pristine defaults.');
  };

  const handleOpenProfileTab = (subTab) => {
    setProfileSubTab(subTab || 'overview');
    setActiveTab('profile');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const savedIds = savedItems.map((s) => s.product?.id).filter(Boolean);
  const comparedIds = comparedProducts.map((p) => p.id);

  return (
    <div className="min-h-screen app-ambient-bg text-[#18213A] flex flex-col antialiased selection:bg-[#3559C7] selection:text-white relative">
      {/* Layered Ambient Light Effects (Fixed in background across all views) */}
      <div className="fixed top-0 left-1/4 w-[500px] h-[500px] bg-[#3559C7]/5 rounded-full blur-[130px] pointer-events-none -z-10" />
      <div className="fixed bottom-1/4 right-10 w-[450px] h-[450px] bg-[#D6AD60]/6 rounded-full blur-[110px] pointer-events-none -z-10" />
      <div className="fixed top-1/2 right-1/3 w-[400px] h-[400px] bg-[#18213A]/3 rounded-full blur-[90px] pointer-events-none -z-10" />

      {/* Toast Notification Banner */}
      {toastMessage && (
        <div className="fixed top-5 right-5 z-50 bg-[#101B3D] text-[#FFF9EF] px-5 py-3 rounded-xl shadow-2xl border border-[#D6AD60]/60 text-xs font-bold animate-in fade-in slide-in-from-top-4 flex items-center gap-2">
          <span className="w-2 h-2 rounded-full bg-[#D6AD60] animate-ping" />
          <span>{toastMessage}</span>
        </div>
      )}

      {/* Modern Top Navigation Bar */}
      <TopNavbar
        activeTab={activeTab}
        setActiveTab={setActiveTab}
        profileSubTab={profileSubTab}
        compareCount={comparedProducts.length}
        savedCount={savedItems.length}
        onOpenProfileTab={handleOpenProfileTab}
      />

      {/* Main Full-Width Centered Content Layout */}
      <main className="flex-1 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 md:py-8 w-full">
        {activeTab === 'landing' && (
          <PageLanding
            onStartFinding={handleStartFinding}
            onSelectCategory={handleSelectCategoryFromOverview}
            onNavigate={(tab) => {
              setActiveTab(tab);
              window.scrollTo({ top: 0, behavior: 'smooth' });
            }}
            featuredProducts={products.slice(0, 3)}
            reviews={reviews.slice(0, 3)}
            onViewDetails={handleViewDetails}
          />
        )}

        {activeTab === 'overview' && (
          <PageOverview
            onStartFinding={handleStartFinding}
            onSelectCategory={handleSelectCategoryFromOverview}
            onNavigate={(tab) => {
              setActiveTab(tab);
              window.scrollTo({ top: 0, behavior: 'smooth' });
            }}
          />
        )}

        {activeTab === 'builder' && (
          <PageRequirementBuilder
            initialCategory={builderCategory}
            onSubmitRequirements={handleSubmitRequirements}
          />
        )}

        {activeTab === 'recommendations' && (
          <PageRecommendations
            result={recommendationResult}
            isLoading={isRecommending}
            onResetRequirements={() => {
              setActiveTab('builder');
              window.scrollTo({ top: 0, behavior: 'smooth' });
            }}
            onViewDetails={handleViewDetails}
            onAddToCompare={handleAddToCompare}
            comparedIds={comparedIds}
            onToggleSave={handleToggleSave}
            savedIds={savedIds}
          />
        )}

        {activeTab === 'explorer' && (
          <PageProductExplorer
            products={products}
            categories={categories}
            onViewDetails={handleViewDetails}
            onAddToCompare={handleAddToCompare}
            comparedIds={comparedIds}
            onToggleSave={handleToggleSave}
            savedIds={savedIds}
          />
        )}

        {activeTab === 'compare' && (
          <PageCompareProducts
            products={products}
            categories={categories}
            comparedProducts={comparedProducts}
            onAddToCompare={handleAddToCompare}
            onRemoveFromCompare={handleRemoveFromCompare}
            onClearCompare={handleClearCompare}
            onSaveComparison={handleSaveComparison}
            onNavigateToExplorer={() => {
              setActiveTab('explorer');
              window.scrollTo({ top: 0, behavior: 'smooth' });
            }}
          />
        )}

        {activeTab === 'community-reviews' && (
          <PageCommunityReviews
            reviews={reviews}
            products={products}
            onCreateReview={handleCreateReview}
            onReportReview={handleReportReview}
          />
        )}

        {activeTab === 'budget-finder' && (
          <PageBudgetFinder
            categories={categories}
            onViewDetails={handleViewDetails}
            onAddToCompare={handleAddToCompare}
            comparedIds={comparedIds}
            onToggleSave={handleToggleSave}
            savedIds={savedIds}
          />
        )}

        {/* Profile Hub (My Profile, Saved Products, My Reviews, My Comparisons, Settings) */}
        {activeTab === 'profile' && (
          <PageProfile
            initialSubTab={profileSubTab}
            savedItems={savedItems}
            savedComparisons={savedComparisons}
            reviews={reviews}
            categories={categories}
            onRemoveSavedProduct={handleToggleSave}
            onViewDetails={handleViewDetails}
            onAddToCompare={handleAddToCompare}
            comparedIds={comparedIds}
            onReopenComparison={handleReopenComparison}
            onDeleteComparison={handleDeleteComparison}
            onDeleteReview={handleDeleteReview}
            onResetAllDemoData={handleResetAllDemoData}
          />
        )}

        {/* Backwards compatibility for legacy tab shortcuts */}
        {activeTab === 'saved-products' && (
          <PageProfile
            initialSubTab="saved"
            savedItems={savedItems}
            savedComparisons={savedComparisons}
            reviews={reviews}
            categories={categories}
            onRemoveSavedProduct={handleToggleSave}
            onViewDetails={handleViewDetails}
            onAddToCompare={handleAddToCompare}
            comparedIds={comparedIds}
            onReopenComparison={handleReopenComparison}
            onDeleteComparison={handleDeleteComparison}
            onDeleteReview={handleDeleteReview}
            onResetAllDemoData={handleResetAllDemoData}
          />
        )}

        {activeTab === 'my-reviews' && (
          <PageProfile
            initialSubTab="reviews"
            savedItems={savedItems}
            savedComparisons={savedComparisons}
            reviews={reviews}
            categories={categories}
            onRemoveSavedProduct={handleToggleSave}
            onViewDetails={handleViewDetails}
            onAddToCompare={handleAddToCompare}
            comparedIds={comparedIds}
            onReopenComparison={handleReopenComparison}
            onDeleteComparison={handleDeleteComparison}
            onDeleteReview={handleDeleteReview}
            onResetAllDemoData={handleResetAllDemoData}
          />
        )}

        {activeTab === 'settings' && (
          <PageProfile
            initialSubTab="settings"
            savedItems={savedItems}
            savedComparisons={savedComparisons}
            reviews={reviews}
            categories={categories}
            onRemoveSavedProduct={handleToggleSave}
            onViewDetails={handleViewDetails}
            onAddToCompare={handleAddToCompare}
            comparedIds={comparedIds}
            onReopenComparison={handleReopenComparison}
            onDeleteComparison={handleDeleteComparison}
            onDeleteReview={handleDeleteReview}
            onResetAllDemoData={handleResetAllDemoData}
          />
        )}
      </main>

      {/* Full-Width Seamless Glassmorphism Footer */}
      <AnimatedFooter
        onNavigate={(tab) => {
          setActiveTab(tab);
          window.scrollTo({ top: 0, behavior: 'smooth' });
        }}
        onStartFinding={handleStartFinding}
      />

      {/* Floating Compare Tray */}
      <CompareTray
        comparedProducts={comparedProducts}
        onRemoveFromCompare={handleRemoveFromCompare}
        onNavigateToCompare={handleNavigateToCompare}
        onClearCompare={handleClearCompare}
      />

      {/* Product Details Modal */}
      <ProductDetailsModal
        product={selectedProductForModal}
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onAddToCompare={handleAddToCompare}
        isCompared={comparedIds.includes(selectedProductForModal?.id)}
        onToggleSave={handleToggleSave}
        isSaved={savedIds.includes(selectedProductForModal?.id)}
      />
    </div>
  );
}
