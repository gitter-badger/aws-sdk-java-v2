${fileHeader}
package ${metadata.fullWaitersPackageName};

import javax.annotation.Generated;

import software.amazon.awssdk.annotation.SdkInternalApi;
import ${metadata.fullClientPackageName}.${metadata.syncInterface};
import ${metadata.fullModelPackageName}.*;
import software.amazon.awssdk.waiters.*;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Generated("software.amazon.awssdk:aws-java-sdk-code-generator")
public class ${className}{

    /**
      * Represents the service client
      */
    private final ${metadata.syncInterface} client;

    private final ExecutorService executorService = Executors.newFixedThreadPool(50);

    /**
      * Constructs a new ${className} with the
      * given client
      * @param client
      *          Service client
      */
    @SdkInternalApi
    public ${className}(${metadata.syncInterface} client){
        this.client = client;
    }

    <#list waiters?values as waiters>
        <#assign outputType = waiters.operationModel.returnType.returnType>
        <#assign inputType = waiters.operationModel.input.variableType>
    /**
      * Builds a ${waiters.waiterName} waiter by using custom parameters
      * waiterParameters and other parameters defined in the waiters
      * specification, and then polls until it determines whether the resource
      * entered the desired state or not, where polling criteria is bound by
      * either default polling strategy or custom polling strategy.
      */
    public Waiter<${inputType}> ${waiters.waiterMethodName}() {

        <#assign acceptorArray = "">
        <#list waiters.acceptors as acceptor>
            <#if acceptor.matcher == "status">
                <#if acceptor.expectedAsNumber == 200>
                    <#assign acceptorArray = acceptorArray + "new HttpSuccessStatusAcceptor(${acceptor.enumState})" + ", ">
                <#else>
                    <#assign acceptorArray = acceptorArray + "new HttpFailureStatusAcceptor(${acceptor.expectedAsNumber}, ${acceptor.enumState})" + ", ">
                </#if>
            <#else>
                <#assign acceptorArray = acceptorArray + "new " + waiters.waiterName + ".Is" + acceptor.expectedAsCamelCase + "Matcher()" + ", ">
            </#if>
        </#list>

        return new WaiterBuilder<${inputType}, ${outputType}>()
                        .withSdkFunction(new ${waiters.operationName}Function(client))
                        .withAcceptors(${acceptorArray?remove_ending(", ")})
                        .withDefaultPollingStrategy(new PollingStrategy(new MaxAttemptsRetryStrategy(${waiters.maxAttempts}), new FixedDelayStrategy(${waiters.delay})))
                        .withExecutorService(executorService)
                        .build();
    }

    </#list>
}
