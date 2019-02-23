using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class collider : MonoBehaviour
{
    public GameObject GO;
    public GameObject Out;
    private void Start()
    {
        Out.SetActive(false);
        GO.SetActive(false);
    }
    void OnCollisionEnter(Collision other)
    {
        if (other.gameObject.name == "Cube")
        {
            GO.SetActive(true);
            StartCoroutine(Example());
        }

    }
    void OnCollisionExit(Collision other)
    {
        if (other.gameObject.name == "Cube")
        {
            Out.SetActive(true);
            StartCoroutine(Example());
        }

    }
    IEnumerator Example()
    {

        yield return new WaitForSeconds(1f);
        GO.SetActive(false);
        yield return new WaitForSeconds(0.3f);
        Out.SetActive(false);
    }

}
