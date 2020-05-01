# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Stocker' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for stocks

	pod 'lottie-ios'
  pod 'SnapKit', '~> 5.0.0'
  pod 'Charts'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'

  def testing_pods
      pod 'Quick'
      pod 'Nimble'
  end

  target 'StockerTests' do
    inherit! :search_paths
    # Pods for testing
    testing_pods
  end

  target 'StockerUITests' do
    # Pods for testing
    testing_pods
  end

end
