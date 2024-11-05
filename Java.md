## 数组转Map
~~~
Map<String,T> map= list.stream().collect(Collectors.toMap(T::getId, Function.identity(), (v1, v2) -> v2));
~~~

## 数组对象转List<String>
~~~
List<String> list= ary.stream().map(a->a.getName()).collect(Collectors.toList());
~~~

## 数组分组转Map
~~~
Map<String,List<T>> map = list.stream().collect(Collectors.groupingBy(T::getId));
~~~
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
## Swagger2和OpenAPI3的注解映射关系
~~~
@Api → @Tag
@ApiIgnore → @Parameter(hidden = true) or @Operation(hidden = true) or @Hidden
@ApiImplicitParam → @Parameter
@ApiImplicitParams → @Parameters
@ApiModel → @Schema
@ApiModelProperty(hidden = true) → @Schema(accessMode = READ_ONLY)
@ApiModelProperty → @Schema
@ApiOperation(value = "foo", notes = "bar") → @Operation(summary = "foo", description = "bar")
@ApiParam → @Parameter
@ApiResponse(code = 404, message = "foo") → @ApiResponse(responseCode = "404", description = "foo")
~~~