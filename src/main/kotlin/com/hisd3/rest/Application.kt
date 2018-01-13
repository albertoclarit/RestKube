package com.hisd3.rest

import spark.kotlin.Http
import spark.kotlin.ignite
import java.net.InetAddress


class Application
fun main(args : Array<String>) {

    val http: Http = ignite()


    val ip = InetAddress.getLocalHost()



    http.get("/") {
        "Hello from Ip with V1 !${ip}"
    }

}