using UnityEngine;
using System.Collections;

public class TubeGenerator : MonoBehaviour
{

    public int numLines = 100;
    public int lineResolution = 100;
    public float scale;
    [Range (0.001f, 0.1f)]
    public float radius = 0.1f;
    public GameObject prefab;


    // Use this for initialization
    void Start()
    {
        if (prefab != null)
        {
            for (int i = 0; i < numLines; i++)
            {
                GameObject obj = Instantiate(prefab);
                TubeRenderer lineRend = obj.GetComponent<TubeRenderer>();
                if (lineRend != null)
                {
                    Vector3 endPosition;
                    Vector3 startPosition = Vector3.zero;
                    endPosition = Random.onUnitSphere;
                    lineRend.vertices = new TubeRenderer.TubeVertex[lineResolution];
                    for (int j = 0; j < lineResolution; j++)
                    {
                        float x = Mathf.Lerp(startPosition.x, endPosition.x, (float)j / lineResolution);
                        float y = Mathf.Lerp(startPosition.y, endPosition.y, (float)j / lineResolution);
                        float z = Mathf.Lerp(startPosition.z, endPosition.z, (float)j / lineResolution);
                        lineRend.vertices[j] = new TubeRenderer.TubeVertex(new Vector3(x, y, z) * scale, radius, Color.white);
                        //lineRend.SetPosition(j, new Vector3(x, y, z) * scale);
                    }
                }
            }
        }

    }

    // Update is called once per frame
    void Update()
    {

    }
}
