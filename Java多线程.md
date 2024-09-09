## 无返回值，等待所有线程执行完毕
~~~
//多线程执行，无返回值
CompletableFuture<?>[] futures = Lists.partition(list, 300)
.stream().map(subList -> CompletableFuture.runAsync(
        () -> System.out.println("无返回值多线程操作...当前参数为："+subList))
).toArray(CompletableFuture[]::new);
//等待所有线程执行完毕
CompletableFuture.allOf(futures).join();
~~~
## 有返回值，等待所有线程执行完毕后汇总结果
~~~
CompletableFuture<?>[] futures = Lists.partition(list, 300).stream().map(subList -> CompletableFuture.supplyAsync(
        () -> "有参数返回"
)).toArray(CompletableFuture[]::new);
//汇总所有任务执行结果
List<Object> results = CompletableFuture.allOf(futures).thenApply(a -> {
    List<Object> rs = new ArrayList<>();
    for (CompletableFuture<?> future : futures) {
        Object futureJoin = future.join();
        if (futureJoin != null) {
            rs.add(futureJoin);
        }
    }
    return rs;
}).join();
~~~