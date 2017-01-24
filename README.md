# BBMVVMProject
an MVVM demo with ReactiveCocoa

##MVVM
MVVM stands for the Model-View-ViewModel pattern.
> Model–view–view-model (MVVM) is a software architectural pattern.
> MVVM facilitates a separation of development of the graphical user interface – be it via a markup language or GUI code – from development of the business logic or back-end logic (the data model). The view model of MVVM is a value converter;[1] meaning the view model is responsible for exposing (converting) the data objects from the model in such a way that objects are easily managed and presented. In this respect, the view model is more model than view, and handles most if not all of the view's display logic.[1] The view model may implement a mediator pattern, organizing access to the back-end logic around the set of use cases supported by the view. -- <i>[Wikipedia](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)</i>

##ReactiveCocoa
`ReactiveCocoa` is a Reactive extensions to Cocoa frameworks, built on top of `ReactiveSwift`.
You can find it on [`ReactiveCocoa`](https://github.com/ReactiveCocoa/ReactiveCocoa).

##Main feature of this demo
#### <i>ViewModel-based navigation</i>.</br>
It's known that in the MVC pattern we handle view controllers by controller-based navigation,like</br>

```Swift
pushViewController(_ viewController: UIViewController, animated: Bool)
popViewController(animated: Bool) -> UIViewController?
```
In MVVM,we handle most events by using viewModels.So we do not directly handle the navigation of controllers.So how to get the viewModel-based navigation work?Here come the tricks by using `ReactiveCocoa`.
First,we construct a <b>navigationEventBus</b> class.

```Swift
class BBNavigationEventBus: NSObject {
    
    static let sharedEventBus: BBNavigationEventBus = BBNavigationEventBus()
    
    private override init() {
        super.init()
    }
    
    dynamic func push(viewModel: BBViewModel, animated: Bool) {}
    
    dynamic func popViewModel(animated: Bool) {}
    
    dynamic func popToRootViewModel(animated: Bool) {}
    
    dynamic func present(viewModel: BBViewModel, animated: Bool, completion: (() -> Void)?) {}
    
    dynamic func dismissViewModel(aniamted: Bool, completion: (() -> Void)?) {}
    
    dynamic func reset(rootViewModel: BBViewModel) {}
}
```
As the code above shown,in the project,we always <b>directly</b> handle navigation by using viewModels.
As a matter of fact,the navigation of controllers is the thing that we can not ever change.So we have to build way to achieve that when we operate viewModels, the corresponding operations of controller execute correctly.
And now it's time for `ReactiveCocoa` to show its power.
We maintain a stack of `UINavigationController` by using a <b>NavigationControllerStack</b> class,in which we can capture the execution of function in <b>navigationEventBus</b>,before when we can get the operations of controllers done.The core code of the stack is shown below.

```Swift
private func registerNavigationHooks() {
        
        navigationEventBus
            .reactive
            .signal(for: #selector(navigationEventBus.push(viewModel:animated:)))
            .observeValues { [weak self](params) in
                if let strongSelf = self, let viewModel = params[0] as? BBViewModel, let animated = params[1] as? Bool {
                    strongSelf.navigationControllers.last?.pushViewController(strongSelf.router.viewControllerFor(viewModel: viewModel),
                                                                               animated: animated)
                }
        }
        
        //other operations...  
    }
```
As the code shows,we can capture the operations and parameters of the navigation of viewModels and then get corresponding operations of controllers done.

####<i>more coming soon...</i>

##References
1.[ReactiveCocoa-GitHub](https://github.com/ReactiveCocoa/ReactiveCocoa) - This is the main page of ReactiveCocoa on GitHub,you can find more details of this astonishing framework here.

2.[MVVM With ReactiveCocoa](http://blog.leichunfeng.com/blog/2016/02/27/mvvm-with-reactivecocoa/) - This is an article which mine is based on.The project in the article is using ReactiveCocoa v2.5 and Objective-C.But the main thought is absolutely the same.You can read more content about MVVM in this brilliant article.





