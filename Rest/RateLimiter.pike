/**
* The RateLimiter will handle all of the rate limiting related
* traffic in order to not get those 429s
*/
class RateLimiter {
  array requestsQueue;
  object constants = Constants();
}
